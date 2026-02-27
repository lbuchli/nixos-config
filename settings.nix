{ hostname }: (builtins.mapAttrs
  (name: valueList: builtins.elem hostname valueList)
{
  hasVirtualization = [ "ifs" ];
  hasProprietaryNvidiaDrivers = [ ];
})
