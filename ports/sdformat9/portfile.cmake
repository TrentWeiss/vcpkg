vcpkg_fail_port_install(ON_TARGET "linux" "uwp")

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO osrf/sdformat
    REF sdformat9_9.3.0
    SHA512 6aff60ff5f71748b51a1252fcdcc393cb12a1aa677ba07048b558f41f94dfabb20dd939204e0e753637b8801587f6ce703be833ddc4116b7a182431bdee9ac34
    HEAD_REF sdf9
    PATCHES
      fixup-deps.patch
      
)

# Ruby is required by the sdformat build process
vcpkg_find_acquire_program(RUBY)
get_filename_component(RUBY_PATH ${RUBY} DIRECTORY)
set(_path $ENV{PATH})
vcpkg_add_to_path(${RUBY_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS 
        -DBUILD_TESTING=OFF
)

vcpkg_install_cmake()

# Restore original path
set(ENV{PATH} ${_path})

# Fix cmake targets and pkg-config file location
vcpkg_fixup_cmake_targets(CONFIG_PATH "lib/cmake/sdformat9")
vcpkg_fixup_pkgconfig()

# Remove debug files
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include
                    ${CURRENT_PACKAGES_DIR}/debug/lib/cmake
                    ${CURRENT_PACKAGES_DIR}/debug/share)

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)
