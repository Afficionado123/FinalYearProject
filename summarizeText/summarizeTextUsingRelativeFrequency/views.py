from django.shortcuts import render
import json
from rest_framework.views import APIView
from rest_framework.response import Response
# Create your views here.
import spacy
import textwrap
from spacy.lang.en.stop_words import STOP_WORDS
from string import punctuation
from heapq import nlargest
import requests
import PyPDF2
from io import BytesIO
from django.http import HttpResponse
class Summarize(APIView):
    punctuation += '\n' 
    stopwords = list(STOP_WORDS)
    word_frequencies = {}
    reduction_rate = 0.1  #defines how small the output summary should be compared with the input
    sentence_tokens=[]
    # Define a view function that takes a PDF URL as a parameter
    def pdf_to_text(request, pdf_url):
    # Get the PDF file from Firebase using requests
        response = requests.get(pdf_url)
        # Check if the request was successful
        if response.status_code == 200:
            # Create a BytesIO object from the response content
            pdf_file = BytesIO(response.content)
            pdf_reader = PyPDF2.PdfFileReader(pdf_file)
            # Initialize an empty string to store the text
            text = ""
            # Loop through all the pages in the PDF file
            for page in range(pdf_reader.numPages):
                # Get the page object
                pdf_page = pdf_reader.getPage(page)
                # Extract the text from the page and append it to the string
                text += pdf_page.extractText()
            return HttpResponse(text, content_type="text/plain")
        else:
        # Return an error message if the request failed
         return HttpResponse("Could not get the PDF file.", status=404)
    def easy_backup(self,text):
        nlp_pl = spacy.load('en_core_web_sm')     #process original text according with the Spacy nlp pipeline for english
        document = nlp_pl(text)                   #doc object

        tokens = [token.text for token in document] #tokenized text

       
        for word in document:
            if word.text.lower() not in self.stopwords:
                if word.text.lower() not in punctuation:
                    if word.text not in self.word_frequencies.keys():
                        self.word_frequencies[word.text] = 1
                    else:
                        self.word_frequencies[word.text] += 1

        max_frequency = max(self.word_frequencies.values())
        print(max_frequency)

        for word in self.word_frequencies.keys():
            self.word_frequencies[word] = self.word_frequencies[word]/max_frequency

        print(self.word_frequencies)
        self.sentence_tokens = [sent for sent in document.sents]

    def get_sentence_scores(self,sentence_tok, len_norm=True):
            sentence_scores = {}
            for sent in sentence_tok:
                word_count = 0
                for word in sent:
                    if word.text.lower() in self.word_frequencies.keys():
                        word_count += 1
                        if sent not in sentence_scores.keys():
                            sentence_scores[sent] = self.word_frequencies[word.text.lower()]
                        else:
                            sentence_scores[sent] += self.word_frequencies[word.text.lower()]
                if len_norm:
                    sentence_scores[sent] = sentence_scores[sent]/word_count
            return sentence_scores
                    
       #sentence scoring with length normalization
    def get_summary(self, sentence_sc, rate):
            summary_length = int(len(sentence_sc)*rate)
            summary = nlargest(summary_length, sentence_sc, key = sentence_sc.get)
            final_summary = [word.text for word in summary]
            summary = ' '.join(final_summary)
            return summary

            
    def post(self,request):
            # text = """I saw ABC back in Neuro-Oncology Clinic today. He comes in for an urgent visit because of increasing questions about what to do next for his anaplastic astrocytoma.
            # Within the last several days, he has seen you in clinic and once again discussed whether or not to undergo radiation for his left temporal lesion. The patient has clearly been extremely ambivalent about this therapy for reasons that are not immediately apparent. It is clear that his MRI is progressing and that it seems unlikely at this time that anything other than radiation would be particularly effective. Despite repeatedly emphasizing this; however, the patient still is worried about potential long-term side effects from treatment that frankly seem unwarranted at this particular time.
            # After seeing you in clinic, he and his friend again wanted to discuss possible changes in the chemotherapy regimen. They came in with a list of eight possible agents that they would like to be administered within the next two weeks. They then wanted another MRI to be performed and they were hoping that with the use of this type of approach, they might be able to induce another remission from which he can once again be spared radiation.
            # From my view, I noticed a man whose language has deteriorated in the week since I last saw him. This is very worrisome. Today, for the first time, I felt that there was a definite right facial droop as well. Therefore, there is no doubt that he is becoming symptomatic from his growing tumor. It suggests that he is approaching the end of his compliance curve and that the things may rapidly deteriorate in the near future.
            # Emphasizing this once again, in addition, to recommending steroids I once again tried to convince him to undergo radiation. Despite an hour, this again amazingly was not possible. It is not that he does not want treatment, however. Because I told him that I did not feel it was ethical to just put him on the radical regimen that him and his friend devised, we compromised and elected to go back to Temodar in a low dose daily type regimen. We would plan on giving 75 mg/sq m everyday for 21 days out of 28 days. In addition, we will stop thalidomide 100 mg/day. If he tolerates this for one week, we then agree that we would institute another one of the medications that he listed for us. At this stage, we are thinking of using Accutane at that point.
            # While I am very uncomfortable with this type of approach, I think as long as he is going to be monitored closely that we may be able to get away with this for at least a reasonable interval. In the spirit of compromise, he again consented to be evaluated by radiation and this time, seemed more resigned to the fact that it was going to happen sooner than later. I will look at this as a positive sign because I think radiation is the one therapy from which he can get a reasonable response in the long term.
            # I will keep you apprised of followups. If you have any questions or if I could be of any further assistance, feel free to contact me."""
            text="""Re: Sample Patient

            Dear Sample Doctor:

            Thank you for referring Mr. Sample Patient for cardiac evaluation. This is a 67-year-old, obese male who has a history of therapy-controlled hypertension, borderline diabetes, and obesity. He has a family history of coronary heart disease but denies any symptoms of angina pectoris or effort intolerance. Specifically, no chest discomfort of any kind, no dyspnea on exertion unless extreme exertion is performed, no orthopnea or PND. He is known to have a mother with coronary heart disease. He has never been a smoker. He has never had a syncopal episode, MI, or CVA. He had his gallbladder removed. No bleeding tendencies. No history of DVT or pulmonary embolism. The patient is retired, rarely consumes alcohol and consumes coffee moderately. He apparently has a sleep disorder, according to his wife (not in the office), the patient snores and stops breathing during sleep. He is allergic to codeine and aspirin (angioedema).

            Physical exam revealed a middle-aged man weighing 283 pounds for a height of 5 feet 11 inches. His heart rate was 98 beats per minute and regular. His blood pressure was 140/80 mmHg in the right arm in a sitting position and 150/80 mmHg in a standing position. He is in no distress. Venous pressure is normal. Carotid pulsations are normal without bruits. The lungs are clear. Cardiac exam was normal. The abdomen was obese and organomegaly was not palpated. There were no pulsatile masses or bruits. The femoral pulses were 3+ in character with a symmetrical distribution and dorsalis pedis and posterior tibiales were 3+ in character. There was no peripheral edema.He had a chemistry profile, which suggests diabetes mellitus with a fasting blood sugar of 136 mg/dl. Renal function was normal. His lipid profile showed a slight increase in triglycerides with normal total cholesterol and HDL and an acceptable range of LDL. His sodium was a little bit increased. His A1c hemoglobin was increased. He had a spirometry, which was reported as normal.In summary, we have a 67-year-old gentleman with risk factors for coronary heart disease. I am concerned with possible diabetes and a likely metabolic syndrome of this gentleman with truncal obesity, hypertension, possible insulin resistance, and some degree of fasting hyperglycemia, as well as slight triglyceride elevation. He denies any symptoms of coronary heart disease, but he probably has some degree of coronary atherosclerosis, possibly affecting the inferior wall by functional testings.

            In view of the absence of symptoms, medical therapy is indicated at the present time, with very aggressive risk factor modification. I explained and discussed extensively with the patient, the benefits of regular exercise and a walking program was given to the patient. He also should start aggressively losing weight. I have requested additional testing today, which will include an apolipoprotein B, LPa lipoprotein, as well as homocystine, and cardio CRP to further assess his risk of atherosclerosis.

            In terms of medication, I have changed his verapamil for a long acting beta-blocker, he should continue on an ACE inhibitor and his Plavix. The patient is allergic to aspirin. I also will probably start him on a statin, if any of the studies that I have recommended come back abnormal and furthermore, if he is confirmed to have diabetes. Along this line, perhaps, we should consider obtaining the advice of an endocrinologist to decide whether this gentleman needs treatment for diabetes, which I believe he should. This, however, I will leave entirely up to you to decide. If indeed, he is considered to be a diabetic, a much more aggressive program should be entertained for reducing the risks of atherosclerosis in general, and coronary artery disease in particular.

            I do not find an indication at this point in time to proceed with any further testing, such as coronary angiography, in the absence of symptoms.

            If you have any further questions, please do not hesitate to let me know.

            Thank you once again for this kind referral.

            Sincerely,

            Sample Doctor, M.D."""
           
            self.easy_backup(text)
            sentence_scores = self.get_sentence_scores(self.sentence_tokens,len_norm=False)        #sentence scoring without lenght normalization
            sentence_scores_rel = self.get_sentence_scores(self.sentence_tokens,len_norm=True)  
            print("- NON_REL: "+ self.get_summary(sentence_scores, self.reduction_rate))
            print("- REL: "+ self.get_summary(sentence_scores_rel, self.reduction_rate))
            return Response(self.get_summary(sentence_scores, self.reduction_rate),status=200)