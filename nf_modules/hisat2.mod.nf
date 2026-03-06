
process HISAT2 {
	
	tag "$name" // Adds name to job submission instead of (1), (2) etc.

	label 'bigMem'
	label 'multiCore'

    publishDir "${params.outdir}",
        mode: "link", overwrite: true, enabled: true

    input:
	    tuple val(name), path(reads)
		val (genome)

	output:
	    path "*bam",       emit: bam
		path "*stats.txt", emit: stats

    script:
	
		def hisat2_options = params.hisat2_args

		if (params.verbose){
			println ("[MODULE] HISAT2 ARGS: " + hisat2_options)
		}
	
		def cores = 2
		def readString = ""

		// Options we add are
		hisat_options += " --no-unal --no-softclip --new-summary"

		if (reads instanceof List) {
			readString = "-1 "+reads[0]+" -2 "+reads[1]
			hisat_options += " --no-mixed --no-discordant"
		}
		else {
			readString = "-U "+reads
		}
		def index = genome["hisat2"]
		
		// TODO: need to add a check if the splice-site infile is present or not, and leave out this parameter otherwise 
		def splices = " --known-splicesite-infile " + genome["hisat2_splices"]
		def hisat_name = name + "_" + genome["name"]

		"""
		hisat2 -p ${cores} ${hisat_options} -x ${index} ${splices} ${readString}  2>${hisat_name}_hisat2_stats.txt | samtools view -bS -F 4 -F 8 -F 256 - > ${hisat_name}_hisat2.bam
		"""

}
