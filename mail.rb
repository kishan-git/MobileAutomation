# Developed By Kishan Kumar
# Date = 19-02-2013

require "mail"
class Mailer



def sendmail(mailrecipient,mailsubject,mailbody)
 $header="Hi All, \n\n"
 time = Time.now
 $mailbody = mailbody
 $header = $header + "Automation Run Status Report"  + "\n\n"
 Mail.defaults do
   delivery_method :smtp, { :address              => "smtp.gmail.com",
                           :port                 => 587,
                           :domain               => 'capillarytech.com',
                           :user_name            => 'prana.automation.report@gmail.com',
                           :password             => 'deal20hunt',
                           :authentication       => nil,
                           :enable_starttls_auto => true,
                           :content_type => 'text/html;charset=UTF-8'
                        }
                        end   
 

Mail.deliver do   
 

   from    'automation@capillary.co.in'
   
   to mailrecipient     #'kishan.kumar@capillarytech.com'#;sanjeev.kumar@capillarytech.com;sandeep.varmac@dealhunt.in'  
  
   subject "Prana UI Automation Report"
  
   add_file(".\\Reports.zip") 

      html_part do

        content_type 'text/html; charset=UTF-8'
        body '<HTML><BODY><H4><font color="blue">Automation Run Status Report</font></H4>' + $mailbody + "<br><H4>Thanks,</H4><H4>Prana Automation Team</H4></BODY></HTML>"

      end   
      
      end
   end


def mailbody()

      filehandle = File.new("./Logs/mail.txt","r")
      mailbody = '<table border=\"0\" cellpadding=\"2\" cellspacing=\"0\" width=\"100%\" style=\"border: #dcdcdc 1px solid;\"><tr valign=\"top\" class=\"TableHeader\"><td bgcolor="#81DAF5"><b>Sl.No</b></td><td bgcolor="#81DAF5"><b>TestCase Name</b></td><td bgcolor="#81DAF5"><b>Status</b></td></tr>'
      rowtemplate = '<tr valign=\"top\"><td>$SLNO</td><td>$TESTCASENAME</td><td align="center" bgcolor="$COLOR" $STATUS </td></tr>'
      ctr = 1
        while (line = filehandle.gets)
          #line = filehandle.gets
          p line
          if line != "\n"

            if line.split("<0>")[1].include? "Pass"
           #   passctr =  passctr + 1
              mailbody = mailbody + '<tr valign=\"top\"><td>' + ctr.to_s + '</td><td>'+ line.split("<0>")[0] + '</td><td align="center" bgcolor="GREEN"><font color="white">Passed</font></td></tr>'
           
            elsif line.split("<0>")[1].include? "Skipped"
            #    skipped = skipped + 1     
                mailbody = mailbody + '<tr valign=\"top\"><td>' + ctr.to_s + '</td><td>'+ line.split("<0>")[0] + '</td><td align="center" bgcolor="Orange"><font color="white">Skipped</font></td></tr>'
            else
            #  failctr =  failctr + 1
              mailbody = mailbody + '<tr valign=\"top\"><td>' + ctr.to_s + '</td><td>'+ line.split("<0>")[0] + '</td><td align="center" bgcolor="Red"><font color="white">Failed</font></td></tr>'
            end 
          end

          ctr = ctr + 1
        end


    filehandle.close
    mailbody = mailbody + "</table><br>"
    sendmail("kishankumar83@gmail.com;rakesh408059@gmail.com","",mailbody)
end  




end

mail = Mailer.new
mail.mailbody()