
def getGenome(name) {

    // Find a file with the same name as the genome in our genomes.d directory

    scriptDir = workflow.projectDir
    
    // die gracefully if the user specified an incorrect genome
    def fileName = scriptDir.toString() + "/genomes.d/" + name + ".genome"
    def testFile = new File(fileName)
    if (!testFile.exists()) {
        println("\nFile >>$fileName<< does not exist. Listing available genomes...\n")
        listGenomes()
    }

    def genomeFH = new File (fileName).newInputStream()

    def genomeValues = [:]  // initialising map. name is also part of each .genome file

    genomeFH.eachLine {
        sections =  it.split("\\s+",2)
        genomeValues[sections[0]] = sections[1]
    }

    return genomeValues

}

def listGenomes(){
    
    println ("These genomes are currently available to choose from:")
    println ("=====================================================")
    def scriptDir = workflow.projectDir + "/genomes.d/"
    // println (scriptDir) // last slash is consumed
    def allFiles = scriptDir.list()
    
    allFiles
    .sort()
    .findAll { it ==~ /.*\.genome$/ }
    .each { file ->

        def genomeFH = new File("${scriptDir}/${file}").newInputStream()
        def name = file.replaceFirst(/\.genome$/, "")

        println(name)

        genomeFH.eachLine { line ->
            if (params.verbose) {
                println "\t${line}"
            }
        }
    }

    println ("\nTo see this list of available genomes with more detailed information about paths and indexes,\nplease re-run the command including '--list_genomes --verbose'\n\n")

    System.exit(1)
}

