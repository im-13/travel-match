class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find_by(uuid: params[:conversation_id])
    #creating a new message here, need to be modified
    @message = Message.new
    @message.user_id = current_user.uuid
    @message.body = params[:message][:body]
    @message.save
    
    link = BelongTo.new(from_node: @message, to_node: @conversation)
    link.save
    @conversation.time_stamp
    @conversation.save
    if @path.nil?
      @path = conversation_path(@conversation)
    end
  end

  private
  #not in use
  def message_params
    params.require(:message).permit(:body)
  end
end