
"""
#to run: `snakemake /global/scratch/fran_catalan/Cellranger/cellranger.snakefile --cores 16`



#config files looks like
{
    "Samples":{1,2,3,4},
    "ref_path":"/global/scratch/fran_catalan/References/refdata-gex-GRCh38-and-mm10-2020-A",
    "data_path"="path/to/fastq/files/"
}
"""
configfile : "config.json"

def get_all_inputs(wildcards):
    inputs = []
    for i in config['Samples']:
        sample=i
        inputs.append("{i}".format(i=i))
    return inputs

rule all:
    input:
        get_all_inputs
rule make_cell_rangersummary:
    input:
        "./{sample}/outs/metrics_summary.csv"
    output:
        "./output/{sample}.summary"
    run:
        shell("cat {input} | wc >{output}".format(input=input[0],output=output[0]))

rule run_cellranger:
    output:
        "./{sample}/outs/filtered_feature_bc_matrix/matrix.mtx.gz"
        "./{sample}/outs/metrics_summary.csv"
    threads: 16
    params:
        slurm_opts=lambda wildcards: "--export ALL "
 					"--mem 160000" 
					"--time 0-4:00:00"
					"--cores 16" 
					"-A co_genomicdata" 
					"-J cellRanger" 
					"-p savio3_bigmem" 
					"-j 3"
					"-o logs/cellranger_%j.logs" 
    run:
        fn_ref = config["ref_path"]
        fastq_Dir = config["data_path"]
        #shell("cellranger count --id {sample}".format(sample=wildcards.sample") --transcriptome {ref}".format(ref=fn_ref") --fastqs {dir}."format(dir=fastq_Dir") --{sample}".format(sample=wildcards.sample") --localcores=16 --localmem=150" )
        shell("cellranger count "
              "--id {sample} " 
              "--transcriptome {ref} "
              "--fastqs {dir} "
              "--sample {sample} " 
              "--localcores=16 "
              "--localmem=150 "
              "".format(sample=wildcards.sample, 
                        ref=fn_ref,
                        dir=fastq_Dir))

