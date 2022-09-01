def _git_version_impl(ctx):

    print("info_file: %s" % ctx.info_file)

    ctx.actions.run_shell(
        inputs  = [ctx.info_file],
        outputs = [ctx.outputs.out],
        command   = "\n".join([
            #If ctx.info_file is does not contain
            #STABLE_GIT_VERSION (--workspace_status_command was not
            #used) then touch output file; otherwise build will fail,
            #leaving the old GIT-VERSION file in the output dir.

            "cat {f} | while read -r key value; do".format(f=ctx.info_file.path),
            "    if [[ $key = STABLE_GIT_VERSION ]]; then",
            "        FOUND=1",
            "        echo $value > {f}".format(f = ctx.outputs.out.path),
            "    fi",
            "done;",
            "if [ $FOUND == 0 ]",
            "then",
            "    touch {f}".format(f = ctx.outputs.out.path),
            "fi"
        ]),
    )

    return [DefaultInfo(files = depset([ctx.outputs.out]))]

###################
git_version = rule(
    implementation = _git_version_impl,
    doc = "Generates GIT-VERSION file",
    attrs = dict(
        out = attr.output(mandatory=True)
    ),
)
