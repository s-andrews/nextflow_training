
def makeFilesChannel(fileList) {    
    
    // def meta = [:]
    def file_ch = Channel.fromFilePairs( getFileBaseNames(fileList), size:-1)
    return(file_ch)

}

def getFileBaseNames(fileList) {

    def baseNames = [:]
    def bareFiles = []

    fileList.each { s ->

        if (params.single_end){
            def matcher = s =~ /^(.*).(fastq|fq).gz$/

            if (matcher.matches()) {
                bareFiles.add(matcher[0][1])
            }
        }
        else{

            if (s =~ /_val_/){
                def matcher = s =~ /^(.*)_(R?[1234]_val_[12]).(fastq|fq).gz$/

                if (matcher.matches()) {
                    if (!baseNames.containsKey(matcher[0][1])) {
                        baseNames[matcher[0][1]] = []
                    }
                    baseNames[matcher[0][1]].add(matcher[0][2])
                }
                else {
                    matcher = s =~ /^(.*).(fastq|fq).gz$/

                    if (matcher.matches()) {
                        bareFiles.add(matcher[0][1])
                    }
                }
            }
            else{
                def matcher = s =~ /^(.*)_(R?[1234]).(fastq|fq).gz$/

                if (matcher.matches()) {
                    if (!baseNames.containsKey(matcher[0][1])) {
                        baseNames[matcher[0][1]] = []
                    }
                    baseNames[matcher[0][1]].add(matcher[0][2])
                }
                else {
                    matcher = s =~ /^(.*).(fastq|fq).gz$/

                    if (matcher.matches()) {
                        bareFiles.add(matcher[0][1])
                    }
                }
            }
        }

    }

    def patterns = []

    baseNames.each { s ->
        def pattern = s.key + "_{" + s.value.join(",") + "}.{fastq,fq}.gz"
        patterns.add(pattern)
    }

    bareFiles.each { s ->
        def pattern = s + ".{fastq,fq}.gz"
        patterns.add(pattern)
    }

    return patterns
}
