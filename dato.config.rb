social_profiles = dato.social_profiles.sort_by(&:position).map do |profile|
  {
    url: profile.url,
    type: profile.profile_type.downcase.gsub(/ +/, '-'),
  }
end

create_data_file "src/_data/settings.yml", :yaml,
  name: dato.site.global_seo.site_name,
  language: dato.site.locales.first,
  intro: dato.home.intro_text,
  copyright: dato.home.copyright,
  social_profiles: social_profiles,
  favicon_meta_tags: dato.site.favicon_meta_tags

create_post "src/index.md" do
  frontmatter :yaml, {
    seo_meta_tags: dato.home.seo_meta_tags,
    layout: 'home',
    paginate: { collection: 'works', per_page: 5 }
  }
end

create_post "src/about.md" do
  frontmatter :yaml, {
    title: dato.about_page.title,
    subtitle: dato.about_page.subtitle,
    photo: dato.about_page.photo.url(w: 800, fm: 'jpg'),
    layout: 'about',
    seo_meta_tags: dato.about_page.seo_meta_tags,
  }

  content dato.about_page.bio
end

directory "src/_works" do
  dato.works.sort_by(&:position).each_with_index do |work, index|
    create_post "#{work.slug}.md" do
      frontmatter :yaml, {
        layout: 'work',
        title: work.title,
        cover_image: work.cover_image.url(w: 450, fm: 'jpg'),
        detail_image: work.cover_image.url(w: 600, fm: 'jpg'),
        position: index,
        excerpt: work.excerpt,
        seo_meta_tags: work.seo_meta_tags,
        extra_images: work.gallery_slides.map { |item| item.image.url(h: 300, fm: 'jpg') }
      }

      content work.description
    end
  end
end
