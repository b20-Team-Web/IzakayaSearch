module ApplicationHelper
    def default_meta_tags
        {
            site: 'ビアサーチ',
            title: 'ビアサーチ',
            reverse: true,
            separator: '|',
            description: '八王子で安く飲める居酒屋をランキングで提供します！ビールやカクテル、平均予算などで絞り込めるため、安く飲みたいニーズにお答えします！ぜひ参考にしてみてください。',
            keywords: 'ビール、カクテル、ワイン、お酒、安い、ランキング',
            canonical: request.original_url,
            noindex: ! Rails.env.production?,
            icon: [
                { href: image_url('fav.ico') },
                { href: image_url('apple-icon.jpg'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
            ],
            og: {
                site_name: 'ビアサーチ',
                title: 'ビアサーチ',
                description: '八王子で安く飲める居酒屋をランキングで提供します！ビールやカクテル、平均予算などで絞り込めるため、安く飲みたいニーズにお答えします！ぜひ参考にしてみてください。',
                type: 'website',
                url: request.original_url,
                image: image_url('ogp.png'),
                locale: 'ja_JP',
            }
        }
    end
end
