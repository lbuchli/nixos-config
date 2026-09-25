{ hostname }: (builtins.mapAttrs
  (name: config: config.${hostname} or config.default)
{
  hasVirtualization = { default = false; ifs = true; };
  hasProprietaryNvidiaDrivers = { default = false; };
  usesZramSwap = { default = true; };
  localOllamaModels = { default = []; ifs = [ "qwen3.8" ]; };
})
