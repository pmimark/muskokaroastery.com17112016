class FeedbacksController < ApplicationController
  before_filter :require_admin, :except => [:new, :create, :contact, :newsletter_signup]

  def index
    @feedbacks = Feedback.order("created_at desc").page(params[:page]).per(20)
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  def new
    @feedback = Feedback.new
  end

  def contact
    @section = Section.where(:slug => "none").first()
    @featured_product = Feature.where(:is_active => true).first()
    contact_page_id = DynamicSetting.find_by_name("contact_page_id").value.to_i
    @page = Page.find(contact_page_id)
    @feedback = Feedback.new
  end

  def newsletter_signup
    api = Mailchimp::API.new(Settings.mailchimp_api_key)
    if params[:email_address] && api.listSubscribe(id: Settings.mailchimp_list_id, email_address: params[:email_address])
      # h = Hominid::API.new(Settings.mailchimp_api_key)
      # list_id = h.find_list_id_by_name(Settings.mailchimp_list_name)
      # h.list_subscribe(list_id, params[:email_address], {}, 'html', false, true, true, false)

      render :nothing => true, :status => :ok, :layout => false
    else

      render :nothing => true, :status => :unprocessable_entity, :layout => false
    end
  end

  def edit
    @feedback = Feedback.find(params[:id])
  end

  def create
    contact_page_id = DynamicSetting.find_by_name("contact_page_id").value.to_i
    @page = Page.find(contact_page_id)
    @feedback = Feedback.new(feedback_params)

    respond_to do |format|
      if @feedback.save
        FeedbackMailer.contact(@feedback).deliver

        # Check if user opted-in to newsletter and signup through Mailchimp's API if true.
        if @feedback.include_in_mailinglist
          api = Mailchimp::API.new(Settings.mailchimp_api_key)
          api.listSubscribe(id: Settings.mailchimp_list_id, email_address: params[:email_address])

          # h = Hominid::API.new(Settings.mailchimp_api_key)
          # list_id = h.find_list_id_by_name(Settings.mailchimp_list_name)
          # # MailChimp API v1.3 method listSubscribe(string apikey, string id, string email_address, array merge_vars, string email_type, bool double_optin, bool update_existing, bool replace_interests, bool send_welcome)
          # h.list_subscribe(list_id, @feedback.email, { 'FNAME' => @feedback.split_name.first, 'LNAME' => @feedback.split_name.last }, 'html', false, true, true, false)
        end

        format.html { redirect_to "/contact", :notice => 'Thank you. Your feedback was successfully sent.' }
        format.js
      else
        format.html { render :action => "contact" }
        format.js
      end
    end
  end

  def update
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      if @feedback.update(feedback_params)
        format.html { redirect_to(@feedback, :notice => 'Feedback was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feedback.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to(feedbacks_url) }
      format.xml  { head :ok }
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :website, :comment,
      :include_in_mailinglist)
  end

end
