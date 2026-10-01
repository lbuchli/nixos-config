{ hostname }: (builtins.mapAttrs
  (name: config: config.${hostname} or config.default)
{
  hasVirtualization = { default = false; ifs = true; };
  hasProprietaryNvidiaDrivers = { default = false; };
  usesZramSwap = { default = true; };
  hasDemoUser = { default = false; dubbo = true; };
  localOllamaModels = { default = [ "qwen3.8-flash-next" ]; };
})
