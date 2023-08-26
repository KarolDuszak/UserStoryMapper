import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_story_mapper/data/implementations/FirebaseBoardApi.dart';
import 'package:user_story_mapper/data/implementations/FirebaseUserApi.dart';
import 'package:user_story_mapper/models/boardModels/member.dart';
import 'package:user_story_mapper/models/boardModels/potentialUser.dart';
import 'package:user_story_mapper/models/userModels/boardInvitation.dart';

import '../../models/boardModels/labelColor.dart';
import '../app/bloc/app_bloc.dart';

class EditMemberForm extends StatefulWidget {
  final Member member;
  final String boardId;

  const EditMemberForm({Key? key, required this.member, required this.boardId})
      : super(key: key);

  @override
  State createState() => _EditMemberForm(boardId, member);
}

enum MemberState {
  notInvited,
  invited,
  accepted,
}

class _EditMemberForm extends State<EditMemberForm> {
  final _formKey = GlobalKey<FormState>();
  late final Member member;
  late final String boardId;
  List<String> roles =
      List<String>.from(<String>["Admin", "Member", "Visitor"]);

  final userId = TextEditingController();
  final userName = TextEditingController();
  final inviteMessage = TextEditingController();
  late String rolePicker;
  late MemberState state;

  _EditMemberForm(String boardId, Member member) {
    this.member = member;
    this.boardId = boardId;
    userId.text = member.id;
    userName.text = member.name;
    rolePicker = member.role;
    inviteMessage.text = "";

    if (member.invitationAccepted) {
      state = MemberState.accepted;
    } else if (member.id != "" && !member.invitationAccepted) {
      state = MemberState.invited;
    } else {
      state = MemberState.notInvited;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return ScaffoldMessenger(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(5),
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                    hintText: "Provide potential user name", labelText: "Name"),
                controller: userName,
              ),
              TextFormField(
                validator: (value) {
                  if (value != member.id && member.id != "") {
                    return "Can not modify board member Id";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText:
                        "Pass user ID (user ID can be found in profile page)",
                    labelText: "User ID"),
                controller: userId,
              ),
              DropdownButtonFormField<String>(
                value: rolePicker,
                icon: const Icon(Icons.assignment_ind_outlined),
                decoration: const InputDecoration(
                    labelText: "Role", hintText: "Role Selector"),
                onChanged: ((newValue) {
                  setState(() {
                    rolePicker = newValue ?? "";
                  });
                }),
                items: roles.map<DropdownMenuItem<String>>(
                  (String role) {
                    return DropdownMenuItem<String>(
                        value: role, child: Text(role));
                  },
                ).toList(),
              ),
              member.id == "" && !member.invitationAccepted
                  ? TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Provide invitation message",
                          labelText: "Invitation Message"),
                      controller: inviteMessage,
                    )
                  : SizedBox(),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: state == MemberState.accepted
                          ? () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Can not save data')),
                                );
                              }
                            }
                          : state == MemberState.notInvited
                              ? () {
                                  FirebaseUserApi().addUserInvitation(
                                      BoardInvitation(
                                          id: boardId,
                                          message: inviteMessage.text,
                                          reciever: userId.text,
                                          inviterId: user.id));
                                  FirebaseBoardApi().addMember(
                                    boardId,
                                    Member(
                                        id: userId.text,
                                        role: rolePicker,
                                        name: userName.text,
                                        votesUsed: 0,
                                        invitationAccepted: false),
                                  );
                                }
                              : null,
                      child: state == MemberState.accepted
                          ? Text("Save")
                          : Text("Invite")),
                  SizedBox(width: 5),
                  ElevatedButton(
                      onPressed: state != MemberState.invited
                          ? () {
                              setState(() {
                                userId.text = member.id;
                                userName.text = member.name;
                                rolePicker = member.role;
                              });
                            }
                          : null,
                      child: Text("Reset")),
                  SizedBox(width: 5),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red[700]),
                      onPressed: state == MemberState.accepted
                          ? () {
                              FirebaseBoardApi()
                                  .deleteMember(boardId, userId.text);
                            }
                          : state == MemberState.invited
                              ? () {
                                  FirebaseBoardApi()
                                      .deleteMember(boardId, userId.text);
                                  FirebaseUserApi().deleteBoardInvitation(
                                      userId.text, boardId);
                                }
                              : null,
                      child: Text("Delete")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
