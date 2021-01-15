vcpkg_check_linkage(ONLY_DYNAMIC_LIBRARY)

vcpkg_from_github(
  OUT_SOURCE_PATH SOURCE_PATH
  REPO ros/urdfdom
  REF 09462aad532c46d4d43c29c16bddf6a08a12561d # 1.0.5
  SHA512 25c148bde78a03f7dcd87c36bc5bd39837169785bd61ff206835ceebc1d213d446d0ed4f6d384d1cd015690926119405c69b44752a42c4e4dc3ad45c5eadb229
  HEAD_REF ros2
  PATCHES
    fix-deps.patch
)

vcpkg_configure_cmake(
  SOURCE_PATH ${SOURCE_PATH}
  PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_fixup_cmake_targets(CONFIG_PATH CMake)
vcpkg_copy_pdbs()

if(EXISTS ${CURRENT_PACKAGES_DIR}/lib/pkgconfig)
    vcpkg_fixup_pkgconfig()
endif()


file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_tools(TOOL_NAMES check_urdf urdf_mem_test urdf_to_graphiz AUTO_CLEAN)

file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
