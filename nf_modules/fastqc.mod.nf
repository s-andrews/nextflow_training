params.nogroup = false
params.no_output = false

process FASTQC {

    tag "$name"

    publishDir "${params.outdir}",
        mode: "link", overwrite: true, enabled: !params.no_output

    input:
        tuple val(name), path(reads)

    output:
        tuple val(name), path("*fastqc*"), emit: all
        path "*.zip", emit: report

    script:

        if (params.nogroup){
            fastqc_args += " --nogroup "
        }

        if (verbose){
            println ("[MODULE] FASTQC ARGS: "+ fastqc_args)
        }

        """
        fastqc ${fastqc_args} -q -t 2 ${reads}
        """
}