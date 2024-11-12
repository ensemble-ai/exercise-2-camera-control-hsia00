# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Jamie Hsi
* *email:* jhsi@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Position lock works as it should. The camera locks onto the target when it moves, always staying in the center, including when we sprint. The 5 by 5 cross is also there, locking ontop of the tartget.

___
### Stage 2 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Framing with horizontal auto-scroll works as it should. The box drawn in the center serves as the border. The camera automatically begins panning left to right regardless of whether the target is moving or not. The target moves along with the box and can not leave beyong the box range.

___
### Stage 3 ###

- [X] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Position lock and lerp smoothing works as it should. The cross (camera position) always stays in the center, regardless of if the target is moving in all directions or if accelerating. If the target is moving, it will be slightly ahead of the cross. When the target stops, the cross will slowly realign itself so that it is ontop of the cross and the target is back in the center of the screen.

___
### Stage 4 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
For this stage, when the target is not accelerating in any direction (moving at normal speed), the target will "fall behind" the camera cross. However, when the target is accelerating, the cross falls behind the target, which is not something we want. When the target stops, there is a delay in which determines when the camera should catch up to the target. The cross will not move if the target is not moving.

___
### Stage 5 ###

- [ ] Perfect
- [X] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
4-way speedup push zone almost works as it should. There is an outer box and an inner box set as the zones. When the target is within the inner box, camera does not move. Once the target leaves the inner box and into the push zone (between inner and outer box), we see an increase of camera speed. When the target is touching the outer line of the box, the camera moves at target speed. I noticed that if we accelerated the target, sometimes it will get stuck inbetween the two lines and the camera will still move at taret speed despite the target not touching the border.
___
# Code Style #


### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
[too many white lines](https://github.com/ensemble-ai/exercise-2-camera-control-hsia00/blob/7c658b836a38d5b310b8ef3ab52df9d204cba216/Obscura/scripts/camera_controllers/position_lock_lerp.gd#L31-L35) - Between lines of code, for easier reading, Godot requires 1 empty line between sections of code, 2 empty lines if between functions and variables.

[use words instead of && or ||](https://github.com/ensemble-ai/exercise-2-camera-control-hsia00/blob/7c658b836a38d5b310b8ef3ab52df9d204cba216/Obscura/scripts/camera_controllers/speedup_push.gd#L45) - while not incorrect, Godot code style prefers using the words AND, OR, NOT instead of the operators &&, || ! when dealing with some boolean equations

[start with a space when commenting](https://github.com/ensemble-ai/exercise-2-camera-control-hsia00/blob/7c658b836a38d5b310b8ef3ab52df9d204cba216/Obscura/scripts/camera_controllers/position_lock.gd#L52) - have a space between the # and your first letter when you are commenting in Godot. A space would not be necessary when commenting out code.
#### Style Guide Exemplars ####
[example of good naming conventions](https://github.com/ensemble-ai/exercise-2-camera-control-hsia00/blob/7c658b836a38d5b310b8ef3ab52df9d204cba216/Obscura/scripts/camera_controllers/speedup_push.gd#L1-L6) - The student did a good job of keeping up with the naming conventions, snake_case when naming variables and PascalCase when naming classes.

[example of correct code order](https://github.com/ensemble-ai/exercise-2-camera-control-hsia00/blob/7c658b836a38d5b310b8ef3ab52df9d204cba216/Obscura/scripts/camera_controllers/framing_auto.gd#L4-L9) -  here we see that the studnet paid close attention to the order of code, with the @export variables first, followed by the public variabels then functions.

The student made sure to avoid excess parenthesis when writing boolean equations.
___
#### Put style guide infractures ####

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####

The student has good coding practices, so there was nothing to point out specifically that was incorrect.

#### Best Practices Exemplars ####

The student made sure that no line of code would go past screen size (usually around 100 char per line) and if there was a possibility of going over, they extended it to the next line.

I noticed that the student pushed frequently to GitHub, which is good practice for keeping code updated and saved, in case of a roll back.

I noticed that the files are named in a way that they are easily distinguishable. The camera files are all filed under the camera_controllers folder, allowing for easy finding and shows good organization.

