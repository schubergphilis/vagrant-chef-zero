all: clean install test

install:
	@bundle install

clean:
	@bundle exec rake clean
test:
	@bundle exec rake rspec_test

vagrant:
	@if [ -a .vagrant ]; then\
		bundle exec vagrant provision;\
	else\
		bundle exec vagrant up;\
	fi

release:
	@bundle exec rake release