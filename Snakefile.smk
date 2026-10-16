IDS = ['1bzc', '1c5z']

rule all:
    input:
        expand("sample_data/{id}/{id}_proteinH.pdb", id=IDS), 
        expand("sample_data/{id}/{id}_protein.pqr", id=IDS),
        expand("sample_data/{id}/{id}_protein.pdbqt", id=IDS),
        expand("sample_data/{id}/{id}_ligand.pdbqt", id=IDS),
        expand("sample_data/{id}/{id}_config.txt", id=IDS),
        expand("sample_data/{id}/{id}_vina_out.pdbqt", id=IDS)


#remove unwanted water molecules, add heavy atoms and hydrogens where needed to new pdb file
#pqr file contains additional info about atomic radii and atomic charges
rule fix_pdb:
    input:
        "sample_data/{id}/{id}_protein.pdb"
    output:
        pdb = "sample_data/{id}/{id}_proteinH.pdb",
        pqr = "sample_data/{id}/{id}_protein.pqr"
    shell:
        """
        pdb2pqr --pdb-output={output.pdb} --pH=7.4 {input} {output.pqr} --whitespace
        """

#output of previous rule to pdbqt
# -xr preserve residues and treat as rigid
# -r retain hydrogens
rule protein_pdbqt:
    input:
        "sample_data/{id}/{id}_protein.pqr"
    output:
        "sample_data/{id}/{id}_protein.pdbqt"
    shell:
        """
        obabel {input} -O {output} -xr -r
        """

#ligand preparation using meeko - specialized for small molecules
rule ligand_pdbqt:
    input:
        "sample_data/{id}/{id}_ligand_opt.mol2"
    output:
        "sample_data/{id}/{id}_ligand.pdbqt"
    shell:
        """
        mk_prepare_ligand.py -i {input} -o {output}
        """

#parse coordinates of crystal ligand from optimized mol2 and write config.txt
#run with --use-conda
rule config:
    input:
        mol2 = "sample_data/{id}/{id}_ligand_opt.mol2",
        receptor = "sample_data/{id}/{id}_protein.pdbqt",
        ligand = "sample_data/{id}/{id}_ligand.pdbqt"
    output:
        "sample_data/{id}/{id}_config.txt"
    conda:
        "docking_pipeline"
    script:
        "config.py"

#run vina using config file
rule run_vina:
    input:
        "sample_data/{id}/{id}_config.txt"
    output:
        "sample_data/{id}/{id}_vina_out.pdbqt"
    shell:
        """
        vina --config {input} --out {output}
        """