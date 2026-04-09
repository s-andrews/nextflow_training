
process BISMARK_DEDUPLICATION {
	
	tag "$bam" // Adds name to job submission instead of (1), (2) etc.

	label 'bigMem'

	publishDir "${params.outdir}",
		mode: "link", overwrite: true

    input:
	    tuple val(name), path(bam)
		val (outputdir)
		val (deduplicate_bismark_args)
		val (verbose)

	output:
		path "*report.txt", emit: report
		tuple val(name), path ("*bam"),        emit: bam

    script:
		if (verbose){
			println ("[MODULE] BISMARK DEDUPLICATION ARGS: " + deduplicate_bismark_args)
		}

		// Options we add are
		deduplication_options = deduplicate_bismark_args
		deduplication_options += " --bam "

		"""
		deduplicate_bismark ${deduplication_options} ${bam}
		"""

}
