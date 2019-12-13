#!/bin/sh

ROOT_DIRECTORY=$PWD #TODO: replace with codebase directory
RL_PUBLIC_FOLDER=/tmp/rl_public_repo
RL_PUBLIC_REPO_URL=https://github.com/AmrMKayid/sync2.git #TODO: replace with rl repo url

clone_and_sync() {
  if [ ! -d "$RL_PUBLIC_FOLDER" ]; then
    git clone "$RL_PUBLIC_REPO_URL" "$RL_PUBLIC_FOLDER"
  else
    cd "$RL_PUBLIC_FOLDER"
    git pull $RL_PUBLIC_REPO_URL
  fi

  rsync -azP -r -u --exclude '.git' $ROOT_DIRECTORY/ $RL_PUBLIC_FOLDER/
}

new_branch_update() {
  now=$(date +'%d-%m-%Y')
  last_commit_msg=$(
    cd $ROOT_DIRECTORY &&
      (git log -1)
  )

  echo "\nCommiting .... ${last_commit_msg}\n"

  cd $RL_PUBLIC_FOLDER/
  git pull $RL_PUBLIC_REPO_URL
  update_branch="update_${now}"

  echo "\nCheckout out new branch: ${update_branch}\n"
  git checkout -B $update_branch

  git add .
  git commit -m "New Update: ${now}" -m "${last_commit_msg}"
  git push --set-upstream origin $update_branch

}

clone_and_sync
new_branch_update
