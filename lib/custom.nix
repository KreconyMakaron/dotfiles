lib: {
  mkBoolOption =
    desc: bool:
    lib.mkOption {
      default = bool;
      example = !bool;
      description = desc;
      type = lib.types.bool;
    };

  forAllSystems = lib.genAttrs [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];

  ifNull = new: old: if old == null then new else old;

  genAttrsSame = names: value: lib.genAttrs names (_: value);
}
