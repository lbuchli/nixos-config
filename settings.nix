{ hostname }: (builtins.mapAttrs
  (name: config: config.${hostname} or config.default)
{
  hasVirtualization = { default = false; ifs = true; };
  hasProprietaryNvidiaDrivers = { default = false; ifs = true; };
  usesZramSwap = { default = true; };
  hasDemoUser = { default = false; dubbo = true; };
  localOllamaModels = { default = [ "bonsai-2:9b" ]; ifs = [ "flint" "bonsai-2:9b" ]; };
  llmhubModels = { default = [ "best-code" "best-chat" "best-reasoning" "Qwen3.8-Flash-Next" ]; ifs = [ "best-code" "best-chat" "best-reasoning" "Qwen3.8-Flash-Next" "claude" ]; };
})
