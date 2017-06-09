function git_prompt_info {
  git_prompt_vars
  GIT_TOGETHER=$(git config git-together.active)
  GIT_DUET=$(echo $(git config --get-regexp ^duet.env.git-.*-name | sed -e 's/^.*-name //' | tr 'A-Z' 'a-z' | sed -e 's/\([a-z]\)[^ +]*./\1/g' ) | sed -e 's/ /+/')
  GIT_PAIR=${GIT_DUET:-`git config user.initials | sed 's% %+%'`}
  GIT_INITIALS=${GIT_TOGETHER:-$GIT_PAIR}
  gitdir=$(git_dir)

  if is_merging "$gitdir"; then
    echo -e " \e[31mMERGING\e[0m"
  elif is_rebasing "$gitdir"; then
    echo -e " \e[31mREBASING\e[0m"
  else
    echo -e " $GIT_INITIALS$SCM_PREFIX$SCM_BRANCH$SCM_STATE$SCM_SUFFIX"
  fi
}

function git_dir {
  (
    while [ "$(pwd)" != / ]; do
      if [ -d .git ]; then
        pwd
        exit
      fi
      cd ..
    done
  )
}

function is_merging {
  gd="$1"

  if [ -z "$gd" ]; then
    return 1
  fi

  [ -f "${gd}/.git/MERGE_HEAD" ]
  return $?
}

function is_rebasing {
  gd="$1"

  if [ -z "$gd" ]; then
    return 1
  fi

  [ -d "${gd}/.git/rebase-apply" ] || [ -d "${gd}/.git/rebase-merge" ]
  return $?
}
