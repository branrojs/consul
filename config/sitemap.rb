# not use compression
class SitemapGenerator::FileAdapter
  def gzip(stream, data); stream.write(data); stream.close end
end
SitemapGenerator::Sitemap.namer = SitemapGenerator::SimpleNamer.new(:sitemap, extension: '.xml')

# default host
SitemapGenerator::Sitemap.verbose = false if Rails.env.test?
SitemapGenerator::Sitemap.default_host = Setting["url"]

# sitemap generator
SitemapGenerator::Sitemap.create do
  pages = ["general_terms"]
  pages.each do |page|
    add page_path(id: page)
  end

  add help_path
  add how_to_use_path
  add faq_path

  add debates_path, priority: 0.7, changefreq: "daily"
  Debate.find_each do |debate|
    add debate_path(debate), lastmod: debate.updated_at
  end

  add proposals_path, priority: 0.7, changefreq: "daily"
  Proposal.find_each do |proposal|
    add proposal_path(proposal), lastmod: proposal.updated_at
  end

  add budgets_path, priority: 0.7, changefreq: "daily"
  Budget.find_each do |budget|
    add budget_path(budget), lastmod: budget.updated_at
  end

  add polls_path, priority: 0.7, changefreq: "daily"
  Poll.find_each do |poll|
    add poll_path(poll), lastmod: poll.starts_at
  end

  add legislation_processes_path, priority: 0.7, changefreq: "daily"
  Legislation::Process.find_each do |process|
    add legislation_process_path(process), lastmod: process.start_date
  end

end
