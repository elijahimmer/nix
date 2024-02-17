# a nice module utility to make all the modules dynamically
{lib}: let
  inherit (builtins) filter map readDir toString mapAttrs attrNames listToAttrs;
  inherit (lib) removeSuffix nameValuePair zipListsWith filterAttrs hasSuffix;
  inherit (lib.filesystem) listFilesRecursive;
  generateModules = folder: let
    findSuffix = suffix: dir: (filter (x: (hasSuffix suffix (toString x))) (listFilesRecursive dir));
    allNixFiles = findSuffix ".nix" folder;
    allModuleNames = map (removeSuffix ".nix") (map baseNameOf allNixFiles);
    zippedList =
      zipListsWith (x: y: nameValuePair x (import y)) allModuleNames
      allNixFiles;
  in
    listToAttrs zippedList;
  generateModulesAuto = root: let
    moduleFolderNames =
      attrNames
      (filterAttrs (_n: v: v == "directory") (readDir (toString root)));
    moduleFolderPaths = map (x: (toString root) + "/" + x) moduleFolderNames;
    zippedList =
      listToAttrs
      (zipListsWith (x: y: nameValuePair x y) moduleFolderNames
        moduleFolderPaths);
  in
    mapAttrs (_n: generateModules) zippedList;
in
  generateModulesAuto ./.
