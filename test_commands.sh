# Go to the root of this project
cd ~/Documents/Workspaces/Docker/debian-tuned

## If the Docker buildx instance is unusable, recreate it
docker buildx rm multiarch
docker buildx create --name multiarch --use

# Build the Docker image
docker buildx build --no-cache --progress=plain --push --platform linux/amd64,linux/arm64/v8 --rm -t wujidadi/debian-tuned:3.5 -t wujidadi/debian-tuned:latest . 2>&1 | tee $D/docker-build-dt-3.5.log

# Create testing container
docker run -d -p 50000:80 -it --name Test wujidadi/debian-tuned:3.5

# Test the container outside itself by each command
docker exec -it Test vim --version | grep 'Included patches'
docker exec -it Test nano -V | grep 'GNU nano, version'

# Test the container outside itself by one command
docker exec -it Test bash -c "vim --version | grep 'Included patches'; \
nano -V | grep 'GNU nano, version'"

# Delete the testing containter finally
docker stop Test; docker rm Test