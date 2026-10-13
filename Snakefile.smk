IDS = [l.strip() for l in open("subset_ids.txt")]

rule all:
    input:
        expand("vina/pqbqt_files/{id}_protein.pdbqt", id=IDS), 
        expand("vina/pdbqt_files/{id}_ligand.pdbqt", id=IDS),
        expand("vina/configs/{id}_vina_config.txt", id=IDS),
        expand("vina/output/{id}_vina_out.pdbqt", id=IDS)

rule prep_receptor:
    input:
        "sample_data/{id}/{id}_protein.pdb"
    output:
        "vina/pdbqt_files/{id}_protein.pdbqt" 
    shell:
        """
        obabel {input} -O {output} -xr -h
        """

rule prep_ligand:
    input:
        "sample_data/{id}/{id}_ligand.sdf"
    output:
        "vina/pdbqt_files/{id}_ligand.pdbqt"
    shell:
        """
        obabel {input} -O {output} -h --partialcharge gasteiger
        """

rule write_config:
    input:
        receptor = "vina/pdbqt_files/{id}_protein.pdbqt",
        ligand = "vina/pdbqt_files/{id}_ligand.pdbqt"
    output:
        "vina/configs/{id}_vina_config.txt"
    shell:
        """
        cat << EOF > {output}
        receptor = {input.receptor}
        ligand = {input.ligand}
        
        center_x = 0.0
        center_y = 0.0
        center_z = 0.0
        size_x = 20.0
        size_y = 20.0
        size_z = 20.0
        exhaustiveness = 8
        EOF
        """

rule run_vina:
    input:
        "vina/configs/{id}_vina_config.txt"
    output:
        "vina/output/{id}_vina_out.pdbqt"
    shell:
        """
        vina --config {input} --out {output}
        """