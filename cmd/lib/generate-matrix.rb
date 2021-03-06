# frozen_string_literal: false

require "utils/github"

require_relative "ci_matrix"

pr_url, = ARGV

pr = GitHub.open_api(pr_url)
labels = pr.fetch("labels").map { |l| l.fetch("name") }

tap = Tap.from_path(Dir.pwd)

syntax_job = {
  name: "syntax",
}

matrix = [syntax_job]

unless labels.include?("ci-syntax-only")
  matrix += CiMatrix.generate(tap, labels: labels)
end

puts JSON.pretty_generate(matrix)
puts "::set-output name=matrix::#{JSON.generate(matrix)}"
