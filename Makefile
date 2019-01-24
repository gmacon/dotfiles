install: .install-py.stamp

.install-py.stamp: Pipfile Pipfile.lock
	pipenv sync
	touch $@
