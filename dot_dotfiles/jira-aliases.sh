
alias git-branch-safe="sed -e 's/[^a-zA-Z0-9]/-/g' -e 's/^-//' -e 's/-*$//' -e 's/--/-/g' | tr '[:upper:]' '[:lower:]'"


git-from-jira () {
    JIRA_ISSUES=$(jira issue list  -a $(jira me) -s "In Progress" -s "Selected for Development" -s "QA")
    JIRA_ISSUE=$(echo $JIRA_ISSUES | fzf --header-lines 1 --reverse)
    git checkout -b sam/$(echo $JIRA_ISSUE | cut -f1 -d' ' | git-branch-safe)
}

jira-my-work () {
    JIRA_USER=$(jira me)
    jira issue list  -a $JIRA_USER -s 'In Progress' -s 'Selected for Development' -s 'QA'
}

jira-pick () {
    JIRA_USER=$(jira me)
    jira issue list  -a $JIRA_USER -s 'In Progress' -s 'Selected for Development' -s 'QA' | fzf --header-lines 1 --reverse | choose 1
    
}

j-qc () {
    # Jira Quick Comment
    # Will take an issue key and quoted string as arguments. If the first argument isn't a valid issue key it will prompt for one.
    # if the body is empty it'll open $EDITOR

    # if the first arg is a valid jira issue key use that else prompt for one
    if [[ $1 =~ ^[A-Z]+-[0-9]+$ ]]; then
        JIRA_ISSUE_KEY=$1
    else
        JIRA_ISSUE_KEY=$(jira-pick)
    fi

    JIRA_USER=$(jira me)
    jira issue comment add $JIRA_ISSUE_KEY "$@"
    echo "$JIRA_ISSUE_KEY"
}

j-close () {

    # In progress not working will probably need to be a separate 'bin' so it can accept the pipe.
        # if the first arg is a valid jira issue key use that else prompt for one
    if [[ $1 =~ ^[A-Z]+-[0-9]+$ ]]; then
        JIRA_ISSUE_KEY=$1
    else
        JIRA_ISSUE_KEY=$(jira-pick)
    fi

    JIRA_USER=$(jira me)
    jira issue transition $JIRA_ISSUE_KEY  Done
    echo "$JIRA_ISSUE_KEY"
}