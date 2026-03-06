params.local = ''
params.no_output = false

process BOWTIE2 {
	
	tag "$name" // Adds name to job submission instead of (1), (2) etc.

	label 'bigMem'
	label 'multiCore'

    publishDir "${params.outdir}",
        mode: "link", overwrite: true, enabled: true

    take:
	    tuple val(name), path(reads)
		genome

	output:
	    tuple val(name), path ("*bam"),        emit: bam
		path "*stats.txt", emit: stats 


	script:
		if (params.verbose){
			println ("[MODULE] BOWTIE2 ARGS: " + params.bowtie2_args)
		}

		cores = 2
		def readString = ""

		// Options we add are
		def bowtie_options = params.bowtie2_args
		bowtie_options +=  " --no-unal " // We don't need unaligned reads in the BAM file
		
		if (params.local == '--local'){
			// println ("Adding option: " + params.local )
			bowtie_options += " ${params.local} " 
		}

		if (reads instanceof List) {
			readString = "-1 " + reads[0] + " -2 " + reads[1]
			bowtie_options += " --no-discordant --no-mixed " // just output properly paired reads
		}
		else {
			readString = "-U " + reads
		}


		def index = genome["bowtie2"]
		def bowtie_name = name + "_" + genome["name"]

		println("Name=${name} Genome name=${genome['name']} bowtie_name=${bowtie_name}")

		"""
		bowtie2 -x ${index} -p ${cores} ${bowtie_options} ${readString}  2>${bowtie_name}_bowtie2_stats.txt | samtools view -bS -F 4 -F 8 -F 256 -> ${bowtie_name}_bowtie2.bam
		"""

}
