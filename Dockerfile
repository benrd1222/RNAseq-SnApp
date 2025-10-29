FROM r-base:4.5.1
 bioconductor/bioconductor_docker:RELEASE_3_21-R-4.5.1

ENV DEBIAN_FRONTEND=noninteractive

RUN pip3 install --upgrade pip

ENV PYTHONPATH "${PYTHONPATH}:/work"
WORKDIR /work

ADD requirements.txt . 
ADD requirements.r .

# installing python libraries
RUN pip3 install -r requirements.txt

# installing r libraries
RUN Rscript requirements.r

#TODO: investigate volumes and decide on running snakemake within the container or snakemake locally with software containerized
# Need to copy over the envrionement and rules for the container
# technically this means that I can run the whole snakemake workflow in a container
# and figure out how to retain the data and .snakemake files in volumes 
# this would allow for individaul project memory by the workflow
COPY . .
