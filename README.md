# Memes Paper Repository
## Spencer Nystrom

This repository contains all analysis code associated with the paper 'Memes: an R interface to the MEME Suite'.

The current version of the manuscript builds inside `snystrom/memes_docker:devel` container.

``` sh
# Clone repository
git clone https://github.com/snystrom/memes_paper.git
cd memes_paper

# Set up docker
docker pull snystrom/memes_docker:devel

# Launch container for interactive use:
docker run -p 8787:8787 -v $(pwd):/mnt/memes_paper -e PASSWORD=your_password snystrom/memes_docker:devel
# Login to Rstudio in your web browser at localhost:8787
# user: rstudio
# password: your_password

# Open /mnt/memes_paper/manuscript.Rmd and run all chunks
```


