function git_prompt_info {
  git_prompt_vars
  GIT_TOGETHER=$(git config git-together.active)
  GIT_DUET=$(echo $(git config --get-regexp ^duet.env.git-.*-name | sed -e 's/^.*-name //' | tr 'A-Z' 'a-z' | sed -e 's/\([a-z]\)[^ +]*./\1/g' ) | sed -e 's/ /+/')
  GIT_PAIR=${GIT_DUET:-`git config user.initials | sed 's% %+%'`}
  GIT_INITIALS=${GIT_TOGETHER:-$GIT_PAIR}
  echo -e " $GIT_INITIALS$SCM_PREFIX$SCM_BRANCH$SCM_STATE$SCM_SUFFIX"
}
