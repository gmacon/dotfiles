install: .install-py.stamp .install-js.stamp

.install-py.stamp: Pipfile Pipfile.lock
	pipenv sync
	touch $@

.install-js.stamp: package.json package-lock.json
	npm ci
	touch $@
