## we only have one jsoo toolchain, why a bazel toolchain?
## because that's how we obtain the js versions of the
## runtime, stdlib, and std_exit libs.

######################################
def _jsoo_toolchain_adapter_impl(ctx):
    return [platform_common.ToolchainInfo(
        name     = ctx.label.name,
        compiler = ctx.file.compiler,
        runtime  = ctx.file.runtime,
        stdlib   = ctx.file.stdlib,
        std_exit = ctx.file.std_exit,
    )]

###############################
jsoo_toolchain_adapter = rule(
    _jsoo_toolchain_adapter_impl,
    attrs = {
        "compiler": attr.label(
            doc = "Jsoo compiler",
            allow_single_file = True,
            executable = True,
            cfg = "exec"
        ),
        "runtime": attr.label(
            doc = "jsoo runtime",
            allow_single_file = True
        ),
        "stdlib": attr.label(
            doc = "OCaml stdlib.cma, converted to js",
            allow_single_file = True
        ),
        "std_exit": attr.label(
            doc = "OCaml std_exit.cmo converted to js",
            allow_single_file = True
        ),
        "_cc_toolchain": attr.label(
            default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")
        ),
    },

    doc = "Defines a js_of_ocaml toolchain.",
    provides = [platform_common.ToolchainInfo],

    # toolchains = [
    #     "@rules_ocaml//toolchain/type:std",
    #     "@bazel_tools//tools/cpp:toolchain_type"
    # ]
)
