class ConversationsController < ApplicationController
  layout false

  def create
    #between is a Conversation model method that checks if a conversation between two id's 
    if between(params[:sender_id],params[:recipient_id]).present? #is a conversation object exist
      @conversation = between(params[:sender_id],params[:recipient_id])
    else
      #@conversation = Conversation.create!(conversation_params)
      sender = User.find_by(uuid: params[:sender_id])
      reciever = User.find_by(uuid: params[:recipient_id])
      @conversation = Conversation.new
      @conversation.user1 = params[:sender_id]
      @conversation.user2 = params[:recipient_id]
      @conversation.save
      channel1 = Channel.new(from_node: sender, to_node: @conversation)
      channel1.save
      channel2 = Channel.new(from_node: reciever, to_node: @conversation)
      channel2.save
    end
    render json: { conversation_id: @conversation.uuid }
  end

  def show
    @conversation = Conversation.find_by(uuid: params[:id])
    @reciever = @conversation.get_other( current_user.uuid, @conversation ) #return the user not equal to this id
    @messages = @conversation.get_messages
    @message = Message.new
  end

  def index
    #will not make a subscription
    @conversation = Conversation.find_by(uuid: params[:id])
    @reciever = @conversation.get_other( current_user.uuid, @conversation ) #return the user not equal to this id
    @messages = @conversation.get_messages
    @message = Message.new
  end

  def destroy
    @conversation = Conversation.find_by(uuid: params[:id])
    
    @messages = @conversation.query_as(:convo).match("convo<-[b:belong_to]-m").pluck(:m)
    @all_rel = @conversation.query_as(:convo).match("convo<-[rel]-a").pluck(:rel)

    @all_rel.each do |r|
      r.destroy
    end
    @messages.each do |m|
      m.destroy
    end
    @conversation.destroy
    redirect_to url_for(:controller => :users, :action => :show_messages)
  end

  def getother(convo, session_user)
    if session_user.uuid == convo.user1?
      return User.find_by(uuid: convo.user2 ) 
    else
      return User.find_by(uuid: convo.user1 )
    end
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

  def between( sender_id, recipient_id ) 
    conversation = Conversation.query_as(:convo).where( "(convo.user1 = '#{sender_id}' AND convo.user2 = '#{recipient_id}') OR (convo.user1 = '#{recipient_id}' AND convo.user2 = '#{sender_id}')" ).pluck(:convo).first
  end


end