usage() {
	echo "0: $0" >&2
	grep "^#/" "$0" | cut -c4- >&2
	exit 1
}

# The default repository and branch can be overridden by the environment.
[ -z "$GITPAID_REPO" ] && REPO="$HOME/.gitpaid" || REPO="$GITPAID_REPO"
[ -z "$GITPAID_BRANCH" ] && BRANCH="master" || BRANCH="$GITPAID_BRANCH"

# Overload the committer's name with the name of the program used to make
# the commit, which will allow tracking begin and end times conveniently.
# Suppress the committer's email to avoid confusion.
export GIT_COMMITTER_NAME="$(basename "$0")"
export GIT_COMMITTER_EMAIL=""

# Everything's easier when the working directory is the repository.
gpinit() {
	[ -d "$REPO" ] || {
		mkdir -p "$REPO"
		git init --bare "$REPO"
	}
	cd "$REPO"
}

# Commit to the branch $BRANCH in the repository (and current working
# directory) $REPO.  Accept a commit message as an argument.
gpcommit() {

	# Write an empty tree to the repository.  This is the appropriate place
	# to manipulate the index to add files (or stdin) to accompany the work
	# done.
	TREE="$(git write-tree)"

	# Override the committer's date with the number of minutes to count for
	# this work session.
	[ -n "$2" ] && {
		export GIT_COMMITTER_DATE="$((1000000000 + $(gpminutes "$2"))) +0000"
	}

	# Commit the tree with the user's message.
	PARENT="$(git rev-parse --verify "$BRANCH" 2>/dev/null || true)"
	[ -z "$PARENT" ] && {
		COMMIT="$(echo "$1" | git commit-tree "$TREE")"
	} || {
		COMMIT="$(echo "$1" | git commit-tree "$TREE" -p "$PARENT")"
	}

	# Clean up after overriding the date.
	[ -n "$2" ] && unset GIT_COMMITTER_DATE

	# Update the tip of the branch to reference the new commit.
	echo "$COMMIT" >"refs/heads/$BRANCH"

}

gpminutes() {
	echo "$1" | grep '^[0-9]*:[0-9][0-9]$' >/dev/null && {
		HOURS="$(echo "$1" | cut -d: -f1)"
		MINUTES="$(echo "$1" | cut -d: -f2)"
	} || {
		HOURS=0
		MINUTES="$1"
	}
	echo "$((60 * $HOURS + $MINUTES))"
}

gpprettytime() {
	[ -z "$1" ] && {
		echo "0:00"
		return
	}
	HOURS="$(($1 / 60))"
	MINUTES="$(($1 % 60))"
	# TODO Round (down) to even half hours?
	[ "$MINUTES" -lt 10 ] && MINUTES="0$MINUTES"
	echo "$HOURS:$MINUTES"
}
