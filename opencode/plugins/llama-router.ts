import { Model, Plugin, Provider } from "@opencode/plugin"

type RouterModel = {
  id: string
  architecture?: {
    input_modalities?: string[]
    output_modalities?: string[]
  }
  meta?: {
    n_ctx?: number
  }
  status?: {
    args?: string[]
  }
}

type RouterResponse = {
  data?: RouterModel[]
}

const DEFAULT_PROVIDER_ID = "llama.cpp"
const DEFAULT_PROVIDER_NAME = "Local (llama.cpp)"
const DEFAULT_PACKAGE = "@opencode/ai/providers/openai-compatible"
const DEFAULT_BASE_URL = "http://127.0.0.1:9931/v1"
const DEFAULT_CONTEXT = 65536
const DEFAULT_OUTPUT = 8192

export default Plugin.define({
  id: "llama-router",
  async setup(ctx) {
    const providerID = Provider.ID.make(
      String(ctx.options.providerID ?? process.env.LLAMA_ROUTER_PROVIDER_ID ?? DEFAULT_PROVIDER_ID),
    )

    // If the provider is already defined in opencode.json, reuse its endpoint and metadata.
    const configured = await ctx.provider
      .list()
      .then((result) => result.data.find((provider) => provider.id === providerID))
      .catch(() => undefined)

    const providerName = String(
      ctx.options.providerName ?? process.env.LLAMA_ROUTER_PROVIDER_NAME ?? configured?.name ?? DEFAULT_PROVIDER_NAME,
    )
    const providerPackage = String(ctx.options.package ?? configured?.package ?? DEFAULT_PACKAGE)
    const baseURL = String(
      ctx.options.baseURL ?? process.env.LLAMA_ROUTER_BASE_URL ?? configured?.settings?.baseURL ?? DEFAULT_BASE_URL,
    ).replace(/\/+$/, "")
    const refreshInterval = Number(ctx.options.refreshInterval ?? 60_000)

    let models: Model.Info[] = []
    let signature = ""

    const signatureOf = (list: Model.Info[]) =>
      JSON.stringify(
        [...list]
          .sort((a, b) => a.id.localeCompare(b.id))
          .map((model) => [
            model.id,
            model.limit.context,
            model.limit.output,
            model.capabilities.input,
            model.capabilities.output,
          ]),
      )

    const getArg = (args: string[], flags: string[]) => {
      const idx = args.findIndex((arg) => flags.includes(arg))
      if (idx === -1) return undefined

      const value = Number(args[idx + 1])
      return Number.isFinite(value) && value > 0 ? value : undefined
    }

    const toModel = (model: RouterModel): Model.Info => {
      const args = model.status?.args ?? []

      // Priority: 1. Loaded runtime n_ctx -> 2. Explicit -c/--ctx-size -> 3. --fit-ctx floor -> 4. Fallback
      const context =
        model.meta?.n_ctx ??
        getArg(args, ["-c", "--ctx-size"]) ??
        getArg(args, ["-fitc", "--fit-ctx"]) ??
        DEFAULT_CONTEXT

      return {
        ...Model.Info.default(providerID, Model.ID.make(model.id)),
        name: model.id,
        capabilities: {
          ...Model.Capabilities.default(),
          input: model.architecture?.input_modalities ?? ["text"],
          output: model.architecture?.output_modalities ?? ["text"],
        },
        limit: {
          context,
          output: Math.min(DEFAULT_OUTPUT, context),
        },
      }
    }

    const loadModels = async (): Promise<Model.Info[] | undefined> => {
      try {
        const res = await fetch(`${baseURL}/models`, {
          signal: AbortSignal.timeout(1500),
        })
        if (!res.ok) return undefined

        const body = (await res.json()) as RouterResponse
        if (!Array.isArray(body.data)) return undefined

        return body.data.filter((model) => typeof model?.id === "string" && model.id.length > 0).map(toModel)
      } catch {
        // llama-server may be offline when OpenCode starts. Keep the last good inventory and retry later.
        return undefined
      }
    }

    const info: Provider.Info = {
      ...Provider.Info.empty(providerID),
      name: providerName,
      activation: "enabled",
      package: providerPackage,
      settings: { baseURL },
    }

    const apply = async () => {
      await ctx.provider.transform((editor) => {
        const existing = editor.get(providerID)

        if (!existing) {
          editor.add({ info, models })
          return
        }

        if (models.length === 0) return

        // Preserve explicitly configured models, then overlay the router's discovered definitions.
        const merged = new Map<string, Model.Info>()
        for (const model of existing.models.values()) merged.set(model.id, model)
        for (const model of models) merged.set(model.id, model)

        editor.models.set(providerID, [...merged.values()])
      })
    }

    const loaded = await loadModels()
    if (loaded) {
      models = loaded
      signature = signatureOf(models)
    }
    await apply()

    if (!Number.isFinite(refreshInterval) || refreshInterval <= 0) return

    const timer = setInterval(() => {
      void (async () => {
        const next = await loadModels()
        if (!next) return

        const nextSignature = signatureOf(next)
        if (nextSignature === signature) return

        models = next
        signature = nextSignature
        await ctx.provider.reload()
      })().catch(console.error)
    }, refreshInterval)

    return () => clearInterval(timer)
  },
})
