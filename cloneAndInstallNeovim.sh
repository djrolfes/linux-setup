#!/bin/bash

NEOVIM_DIR="neovim"
REPO_URL="https://github.com/neovim/neovim"
DESIRED_TAG="stable"
FORCE_INSTALL=false

# Check for --force flag
for arg in "$@"; do
    if [[ "$arg" == "--force" || "$arg" == "-f" ]]; then
        FORCE_INSTALL=true
    fi
done

# Clone if missing, and enable force install
if [ ! -d "$NEOVIM_DIR" ]; then
    echo "Neovim directory does not exist. Cloning and forcing install..."
    git clone "$REPO_URL" "$NEOVIM_DIR"
    FORCE_INSTALL=true
fi

cd "$NEOVIM_DIR" || exit 1

echo "Fetching tag '$DESIRED_TAG' from upstream..."
git fetch --tags #"refs/tag/$DESIRED_TAG:refs/tags/$DESIRED_TAG" --force

# Get commit hashes to compare
REMOTE_COMMIT=$(git ls-remote --tags origin "$DESIRED_TAG" | cut -f1)
LOCAL_COMMIT=$(git rev-parse "refs/tags/$DESIRED_TAG" 2>/dev/null)

echo "Remote Commit: $REMOTE_COMMIT"
echo "Local Commit:  $LOCAL_COMMIT"

if $FORCE_INSTALL || [ "$REMOTE_COMMIT" != "$LOCAL_COMMIT" ]; then
    echo "Installing Neovim from '$DESIRED_TAG'..."
    git checkout "tags/$DESIRED_TAG" -B "$DESIRED_TAG"
    make distclean
    make CMAKE_BUILD_TYPE=Release
    sudo make install
else
    echo "Already on the latest '$DESIRED_TAG' tag. No rebuild needed."
fi
