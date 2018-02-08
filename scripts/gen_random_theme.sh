curl https://source.unsplash.com/random/1920x1080 -L > random_wall.png && wal -i random_wall.png -a 90 -g -c || echo "Oh no, it failed!" && exit 1
