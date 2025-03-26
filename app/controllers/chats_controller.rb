class ChatsController < ApplicationController
  def index
    # Change from .recent to .order(created_at: :asc)
    @chats = Chat.order(created_at: :asc)
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(chat_params)
    
    # Use OpenAI Service to generate response
    openai_service = OpenaiService.new
    @chat.response = openai_service.generate_response(@chat.prompt)
    
    respond_to do |format|
      if @chat.save
        # Broadcast the new chat to all connected clients
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append('chat_messages', partial: 'chats/chat_message', locals: { chat: @chat }),
            turbo_stream.update('new_chat_form', partial: 'chats/form')
          ]
        end
        format.html { redirect_to chats_path }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update('new_chat_form', partial: 'chats/form', locals: { chat: @chat })
        end
        format.html { render :index }
      end
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:prompt)
  end
end