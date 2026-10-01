{ hostname }: (builtins.mapAttrs
  (name: config: config.${hostname} or config.default)
{
  hasVirtualization = { default = false; ifs = true; };
  hasProprietaryNvidiaDrivers = { default = false; };
  usesZramSwap = { default = true; };
  hasDemoUser = { default = false; dubbo = true; };
  localOllamaModels = { default = [ "north-mini-code-1.0:q4_K_M" ]; ifs = [ "north-mini-code-1.0:q4_K_M" "qwen3.8-flash-next" ]; };
})
