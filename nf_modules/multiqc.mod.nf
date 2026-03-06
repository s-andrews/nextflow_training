
params.prefix = "" 

process MULTIQC {
	
	// dynamic directive
	memory { 2.GB * task.attempt }  
	errorStrategy { sleep(Math.pow(2, task.attempt) * 30 as long); return 'retry' }
	maxRetries 3

    publishDir "${params.outdir}",
        mode: "link", overwrite: true, enabled: !params.no_output

    input:
	    path (file)

	output:
	    path "*html",       emit: html
		
	script:

		
		if (verbose){
			println ("[MODULE] MULTIQC ARGS: " + params.multiqc_args)
		}
	
		"""
		multiqc $multiqc_args -x work --filename ${params.prefix}multiqc_report.html .
		"""
}
