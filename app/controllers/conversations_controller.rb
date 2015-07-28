class ConversationsController < ApplicationController
  layout false

  def create
    #between is a Conversation model method that checks if a conversation between two id's 
    if Conversation.between(params[:sender_id],params[:recipient_id]).present? #is a conversation object exist
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id])
    else
      #@conversation = Conversation.create!(conversation_params)
      sender = User.find_by(uuid: params[:sender_id])
      reciever = User.find_by(uuid: params[:recipient_id])
      @conversation = Conversation.new
      @conversation.user1 = params[:sender_id]
      @conversation.user2 = params[:recipient_id]
      #@conversation.save , not necessary to do this
      channel1 = Channel.new(from_node: sender, to_node: @conversation)
      channel1.save
      channel2 = Channel.new(from_node: reciever, to_node: @conversation)
      channel2.save
    end
    render json: { conversation_id: @conversation.uuid }
  end

  def show
=begin
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
=end

    @conversation = Conversation.find_by(uuid: params[:id])
    @reciever = @Conversation.get_other( current_user.uuid ) #return the user not equal to this id
    @messages = @conversation.get_messages
    @message = Message.new

  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

end