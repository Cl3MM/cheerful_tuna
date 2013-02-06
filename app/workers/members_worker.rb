class MembersWorker
  include Sidekiq::Worker

  def perform member_id
    member = Member.find_by_id(member_id)
    member.contacts.each do |contact|
      contact.tag_list = "member"
      contact.save
    end
  end
end
