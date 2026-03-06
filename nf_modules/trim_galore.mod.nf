
params.singlecell = ''
params.rrbs       = ''
params.pbat       = ''
params.clock      = false
params.single_end = false
// For Epigenetic Clock Processing
params.three_prime_clip_R1 = ''
params.three_prime_clip_R2 = ''
params.no_output = false


process TRIM_GALORE {	
    
	tag "$name"                         // Adds name to job submission instead of (1), (2) etc.

	label 'multiCore'                    // sets cpus = 8
	
	// dynamic directive
	memory { 1.GB * task.attempt }  
	errorStrategy { sleep(Math.pow(2, task.attempt) * 30 as long); return 'retry' }
	maxRetries 2
    
    publishDir "${params.outdir}",
        mode: "link", overwrite: true, enabled: !params.no_output

	input:
	    tuple val (name), path (reads)

	output:
	    tuple val(name), path ("*fq.gz"), emit: reads
		path "*trimming_report.txt", optional: true, emit: report
		

    script:
		if (params.verbose){
			println ("[MODULE] TRIM GALORE ARGS: " + params.trim_galore_args)
		}
		
		def pairedString = ""
		if (params.single_end){
			// paired-end mode may be overridden, see e.g. TrAEL-seq Indexing
		}
		else{
			if (reads instanceof List) {
				pairedString = "--paired"
			}
		}

        // Set multi-core
		params.trim_galore_args += " -j 2 "

		if (params.rrbs){
			params.trim_galore_args = params.trim_galore_args + " --rrbs "
		}
			
		if  (params.pbat){
			params.trim_galore_args = params.trim_galore_args + " --clip_r1 ${params.pbat} "
			if (pairedString == "--paired"){
				params.trim_galore_args = params.trim_galore_args + " --clip_r2 ${params.pbat} "
			}
		}

		"""
		trim_galore ${params.trim_galore_args} ${pairedString} ${reads}
		"""

}
