require 'mechanize'

class CourseManager
  def CourseManager.add_course(name, crn, code, instructor)
    course = Course.create(:name => name, :crn => crn, :code => code, :instructor => instructor)
    course.save
  end

  def CourseManager.get_spots(crn)
    bot = Mechanize.new
    bot.user_agent_alias = 'Mac Safari'
    page = bot.get('https://eas.admin.uillinois.edu/eas/servlet/EasLogin?redirect=https://webprod.admin.uillinois.edu/ssa/servlet/SelfServiceLogin?appName=edu.uillinois.aits.SelfServiceLogin&dad=BANPROD1')  
    login_form = page.form('easForm')
    login_form.inputEnterpriseId = "netid"
    login_form.password = "password"
    page = bot.submit(login_form, login_form.button_with(:value => 'Login'))
    page = bot.get('https://ui2web1.apps.uillinois.edu/BANPROD1/bwskfcls.p_sel_crse_search')
    term_form = page.form_with(:action => '/BANPROD1/bwckgens.p_proc_term_date')
    term_form.field_with(:name => 'p_term').options[1].select # Select Spring 2014 (latest) semester
    page = bot.submit(term_form, term_form.button_with(:value => 'Submit'))
    options_form = page.form_with(:action => '/BANPROD1/bwskfcls.P_GetCrse')
    page = bot.submit(options_form, options_form.button_with(:value => 'Advanced Search'))
    crn_form = page.form_with(:action => '/BANPROD1/bwskfcls.P_GetCrse_Advanced')
    crn_form.crn = crn
    page = bot.submit(crn_form, options_form.button_with(:name => 'SUB_BTN'))
  end

  def CourseManager.reset()
    Course.delete_all
    
    # TODO: populate courses collection here...
  end
end
