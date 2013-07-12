all: clean install test

install:
	@bundle install

clean:
	@bundle exec vagrant destroy -f
	@rm -rf coverage
	@rm -rf .vagrant
	@rm Gemfile.lock
	@rm -rf pkg

test:
	@bundle exec rake test

vagrant:
	@bundle exec vagrant up

release:
	@bundle exec rake release