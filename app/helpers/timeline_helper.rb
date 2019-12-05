module TimelineHelper
  def create_timeline_post(publisher, content)
    Timeline.create(publisher: publisher,
                    images: [publisher.profile_pic],
                    kind: 'news',
                    creation: 'auto',
                    content: content)
  end
end
