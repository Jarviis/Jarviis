namespace :docker do
  task build: ['docker:build:web', 'docker:build:app', 'assets:clobber']

  namespace :build do
    task app: ['assets:precompile', 'assets:clean'] do
      sh "ln -snf Dockerfile.app Dockerfile"
      sh "docker build -t 'avgerinos/jarviis:latest' ."
      sh "rm -f Dockerfile"
    end

    task web: ['assets:precompile', 'assets:clean'] do
      sh "ln -snf Dockerfile.web Dockerfile"
      sh "docker build -t 'avgerinos/jarviis-web:latest' ."
      sh "rm -f Dockerfile"
    end
  end
end
